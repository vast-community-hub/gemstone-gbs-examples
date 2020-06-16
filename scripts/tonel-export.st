| writer path |
path := (CfsPath named: '<insert path to root gemstone-gbs-examples local repo here>').
writer := TonelWriter new.
writer
	addLatestConfigurationMapNamed: 'GemStoneGBSExamples';
	addApplicationsFromConfigurationMaps.
writer writeProjectInto: path.
