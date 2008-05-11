	# Load the Module::Install bundled in ./inc/
	use inc::Module::Install;

	# Define metadata
	name 'MOSES-MOBY';
	version '0.86';
	license 'perl';
	abstract
'This distribution aids in the creation of BioMOBY perl based web services.';
	all_from 'lib/MOSES/MOBY.pm';

	# Specific dependencies
	requires 'Carp'             => 0;
	requires 'CGI'              => 0;
	requires 'File::Spec'       => 0.80;    
	requires 'SOAP::Lite'       => 0.69;
	requires 'XML::LibXML'      => 1.62;
	requires 'Log::Log4perl'    => 1.12;
	requires 'Template'         => 1.11;
	requires 'Config::Simple'   => 4.58;
	requires 'IO::Stringy'      => 2.110;
	requires 'Unicode::String'  => 2.09;
	requires 'File::HomeDir'    => 0.65;
	requires 'File::ShareDir'   => 0.05;
	requires 'Class::Inspector' => 1.17;
	requires 'Params::Util'     => 0.28;

	#    requires        'Want'     		=> 0;
	if ( not( $^O =~ /MSWin32|Windows_NT/i ) ) {
	requires 'Want'       => '0.18';
	requires 'IO::Prompt' => '0.99.2';
	}
	build_requires 'Test::More' => '0.42';
	no_index 'directory'        => 'bin/scripts';

	install_script 'bin/scripts/moses-cache-tester.pl';
	install_script 'bin/scripts/moses-config-status.pl';
	install_script 'bin/scripts/moses-generate-datatypes.pl';
	install_script 'bin/scripts/moses-generate-services.pl';
	install_script 'bin/scripts/moses-install.pl';
	install_script 'bin/scripts/moses-known-registries.pl';
	install_script 'bin/scripts/moses-local-cache.pl';
	install_script 'bin/scripts/moses-testing-parser.pl';
	install_script 'bin/scripts/moses-testing-service.pl';
	install_script 'bin/scripts/moses-universal-testing.pl';
	install_script 'bin/scripts/moses-user-registries.pl';

	install_share 'share';

	auto_install;
	WriteAll;
