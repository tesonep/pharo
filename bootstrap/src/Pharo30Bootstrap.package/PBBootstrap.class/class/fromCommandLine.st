instance creation
fromCommandLine
	| options architecture buildNumber |
	options := CommandLineArguments default.
	architecture := options optionAt: 'ARCH' ifAbsent: [ '32' ].
	buildNumber := options optionAt: 'BUILD_NUMBER' ifAbsent: [ '1' ].
	
	^ super new
		architecture: architecture;
		buildNumber: buildNumber;
		imageName: 'bootstrap';
		yourself