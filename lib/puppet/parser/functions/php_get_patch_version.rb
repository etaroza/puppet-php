module Puppet::Parser::Functions
  newfunction(:php_get_patch_version, :type => :rvalue) do |args|
    version = args[0]

    # Get secure version data
    Puppet::Parser::Functions.function('hiera')
    secure_versions = function_hiera( [ 'php::config::secure_versions' ] )

    # Specify secure version if no minor point specified
    patch_version = case version.to_s
                    when '7', '7.1'
                      secure_versions['7.1']
                    when '7.0'
                      secure_versions['7.0']
                    when '5', '5.6'
                      secure_versions['5.6']
                    when '5.5'
                      secure_versions['5.5']
                    else
                      version.to_s
                    end

    # Warn on insecure versions
    display_secure_warning_local = args[1]
    display_secure_warning_hiera = function_hiera( [ 'php::config::secure_warning' ] )
    if display_secure_warning_local && display_secure_warning_hiera
      Puppet::Parser::Functions.function('versioncmp')
      warning = nil

      # Version is greater than or equal to 7.1.0 and less than the 7.1 secure version
      if function_versioncmp( [ patch_version, '7.1' ] ) >= 0 && function_versioncmp( [ patch_version, secure_versions['7.1'] ] ) < 0
        warning = ['7.1.X', secure_versions['7.1']]
      # Version is greater than or equal to 7.0.0 and less than the 7.0 secure version
      elsif function_versioncmp( [ patch_version, '7.0' ] ) >= 0 && function_versioncmp( [ patch_version, secure_versions['7.0'] ] ) < 0
        warning = ['7.0.X', secure_versions['7.0']]
      # Version is greater than or equal to 5.6.0 and less than the 5.6 secure version
      elsif function_versioncmp( [ patch_version, '5.6' ] ) >= 0 && function_versioncmp( [ patch_version, secure_versions['5.6'] ] ) < 0
        warning = ['5.6.X', secure_versions['5.6']]
      # Version is less than the minimum secure version
      elsif function_versioncmp( [ patch_version, secure_versions['5.5'] ] ) < 0
        warning = ['5.5.X', secure_versions['5.5']]
      end

      unless warning.nil?
        Puppet::Parser::Functions.function('warning')
        statement = 'You are installing PHP %s which is known to be insecure. The current secure %s version is %s'
        function_warning( [ sprintf( statement, patch_version, warning[0], warning[1] ) ] )
      end
    end

    return patch_version
  end
end
