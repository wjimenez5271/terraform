package config

import (
	"testing"
)

func TestValidateCount(t *testing.T) {
	cases := []struct {
		Input string
		Err   bool
	}{
		{
			"5",
			false,
		},
		{
			"${count.index}",
			true,
		},
		{
			"${module.foo.bar}",
			true,
		},
		{
			"${resource.foo.bar}",
			true,
		},
		{
			"${var.bar}",
			false,
		},
		{
			"foo ${var.bar}",
			true,
		},
	}

	for _, tc := range cases {
		c, err := NewRawConfig(map[string]interface{}{"count": tc.Input})
		if err != nil {
			t.Fatalf("%s: err: %s", tc.Input, err)
		}
		c.Key = "count"

		errs := validateCount(c, "foo")
		if len(errs) > 0 != tc.Err {
			t.Fatalf("%s: err: %s", tc.Input, errs)
		}
	}
}
