"""Global configuration variables for chemporp"""

from chemporp.featurizers.molgraph.molecule import SimpleMoleculeMolGraphFeaturizer

DEFAULT_ATOM_FDIM, DEFAULT_BOND_FDIM = SimpleMoleculeMolGraphFeaturizer().shape
DEFAULT_HIDDEN_DIM = 300
