"""Unit tests for VivadoStructuralErrorInjection class"""

# Disable this since we are testing a class
# pylint: disable=duplicate-code

import unittest

from bfasst.flows.flow_utils import create_build_file
from bfasst.flows.vivado_structural_error_injection import VivadoStructuralErrorInjection
from bfasst.paths import (
    DESIGNS_PATH,
    NINJA_BUILD_PATH,
    FLOWS_PATH,
)


class TestVivadoStructuralErrorInjection(unittest.TestCase):
    """Unit tests for VivadoStructuralErrorInjection class"""

    @classmethod
    def setUpClass(cls):
        # overwrite the build file so it is not appended to incorrectly
        create_build_file()

        cls.flow = VivadoStructuralErrorInjection(DESIGNS_PATH / "byu/alu")
        cls.flow.create_rule_snippets()
        cls.flow.create_build_snippets()

    def test_rule_snippets_exist(self):
        """Test that there is a rule for vivado, ioparse, phys_netlist,
        bit_to_fasm, fasm_to_netlist, compare, and inject"""
        with open(NINJA_BUILD_PATH, "r") as f:
            ninja_rules = f.read()

        self.assertIn("rule vivado", ninja_rules)
        self.assertIn("rule vivado_ioparse", ninja_rules)
        self.assertIn("rule phys_netlist", ninja_rules)
        self.assertIn("rule bit_to_fasm", ninja_rules)
        self.assertIn("rule fasm_to_netlist", ninja_rules)
        self.assertIn("rule compare", ninja_rules)
        self.assertIn("rule inject", ninja_rules)

    def test_get_top_level_flow_path(self):
        self.assertEqual(
            self.flow.get_top_level_flow_path(),
            FLOWS_PATH / "vivado_structural_error_injection.py",
        )


if __name__ == "__main__":
    unittest.main()
