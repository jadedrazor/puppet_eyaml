# Install and configure eyaml
# keysdirectory is the directory the secure keys are stored in, /keys will be appended to whatever value is used

class puppet_eyaml (
  $keysdirectory = '/etc/puppet/secure/'){

  
  package {'hiera-eyaml':
    ensure => present,
    provider => 'gem';
  }


  file { [ "$keysdirectory" ]:
    ensure => directory,
    recurse => 'true',
    owner   => 'puppet',
    group   => 'puppet',   
    mode    => '0500'    
  }

  # This generates secure keys for the EYAML encryption.  If you want to use your own key to match any crypted content you'll need to replace these keys with your own.
  exec {'generate-eyaml-keys':
    path      => [ '/usr/bin', '/bin', '/usr/local/bin' ],
    command   =>  "eyaml createkeys",
    logoutput => on_failure,
    creates   => "$keysdirectory/keys/private_key.pkcs7.pem",
    cwd       => "$keysdirectory/",
    timeout   => 0,
    require   => [ File["$keysdirectory"], 
                    Package['hiera-eyaml'] ]
  }

}
