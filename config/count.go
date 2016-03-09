package config

import (
	"fmt"
	"strconv"

	"github.com/hashicorp/hil"
	"github.com/hashicorp/hil/ast"
)

func validateCount(c *RawConfig, n string) []error {
	var errs []error
	for _, v := range c.Variables {
		switch v.(type) {
		case *CountVariable:
			errs = append(errs, fmt.Errorf(
				"%s: count can't reference count variable: %s",
				n,
				v.FullKey()))
		case *ModuleVariable:
			errs = append(errs, fmt.Errorf(
				"%s: count can't reference module variable: %s",
				n,
				v.FullKey()))
		case *ResourceVariable:
			errs = append(errs, fmt.Errorf(
				"%s: count can't reference resource variable: %s",
				n,
				v.FullKey()))
		case *UserVariable:
			// Good
		default:
			panic("Unknown type in count var: " + n)
		}
	}

	// Interpolate with a fixed number to verify that its a number.
	c.interpolate(func(root ast.Node) (string, error) {
		// Execute the node but transform the AST so that it returns
		// a fixed value of "5" for all interpolations.
		out, _, err := hil.Eval(
			hil.FixedValueTransform(
				root, &ast.LiteralNode{Value: "5", Typex: ast.TypeString}),
			nil)
		if err != nil {
			return "", err
		}

		return out.(string), nil
	})
	_, err := strconv.ParseInt(c.Value().(string), 0, 0)
	if err != nil {
		errs = append(errs, fmt.Errorf(
			"%s: resource count must be an integer",
			n))
	}
	c.init()

	return errs
}
