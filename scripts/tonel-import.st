| loader path |
path := (CfsPath named: '<insert path to root gemstone-gbs-examples local repo here>').
loader := TonelLoader readFromPath: path.
loader
	beUnattended;
	useGitVersion.
loader loadAllMapsWithRequiredMaps.
