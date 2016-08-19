# knife-ec2

![Alt Text](https://github.com/yhidetoshi/Pictures/raw/master/aws/knife-ec2.png)

### knife-ec2(動作環境のメモ)
```
# gem list | grep knife
knife-ec2 (0.13.0)
knife-solo (0.6.0)
knife-windows (1.5.0)
```

```
Rubyはrvmでインストール

# ruby -v
ruby 2.2.4p230 (2015-12-16 revision 53155) [x86_64-linux]

# which ruby
/usr/local/rvm/rubies/ruby-2.2.4/bin/ruby

# which gem
/usr/local/rvm/rubies/ruby-2.2.4/bin/gem
```

```
# knife configure
-> 全てデフォルトでファイルを作成してから下記の通りに編集した。

->ChefのendpointはChef
# pwd
/root/.chef

# cat knife.rb
log_level                :info
log_location             STDOUT
node_name                'admin'
client_key               '/root/.chef/admin.pem'
validation_client_name   'dev-validator'
validation_key           '/root/.chef/dev-validator.pem'
chef_server_url          'https://ip-10-0-0-168.ap-northeast-1.compute.internal/organizations/dev'
syntax_check_cache_path  '/root/.chef/syntax_check_cache'
knife[:aws_access_key_id] = "Access-key"
knife[:aws_secret_access_key] = "Secret-key"
```


`# knife ec2 server list --region ap-northeast-1`
```
Instance ID  Name                                    Public IP       Private IP  Flavor    Image         SSH Key        Security Groups  IAM Profile  State
```

`# knife ec2 server create --region ap-northeast-1 --availability-zone <AZ> --flavor <instance-type> --image <iam-id> --subnet <subnet-id> --security-group-ids <SG-id> --ssh-key <key-name>`


```
# knife ec2 server create -help
knife ec2 server create (options)
        --associate-eip IP_ADDRESS   Associate existing elastic IP address with instance after launch
        --associate-public-ip        Associate public ip to VPC instance.
        --windows-auth-timeout MINUTES
                                     The maximum time in minutes to wait to for authentication over the transport to the node to succeed. The default value is 25 minutes.
    -Z, --availability-zone ZONE     The Availability Zone
        --aws-access-key-id KEY      Your AWS Access Key ID
        --aws-config-file FILE       File containing AWS configurations as used by aws cmdline tools
        --aws-connection-timeout MINUTES
                                     The maximum time in minutes to wait to for aws connection. Default is 10 min
        --aws-credential-file FILE   File containing AWS credentials as used by AWS command line tools
        --aws-profile PROFILE        AWS profile, from AWS credential file and AWS config file, to use
    -K SECRET,                       Your AWS API Secret Access Key
        --aws-secret-access-key
        --aws-session-token TOKEN    Your AWS Session Token, for use with AWS STS Federation or Session Tokens
        --user-data USER_DATA_FILE   The EC2 User Data file to provision the instance with
        --bootstrap-curl-options OPTIONS
                                     Add options to curl when install chef-client
        --bootstrap-install-command COMMANDS
                                     Custom command to install chef-client
        --bootstrap-no-proxy [NO_PROXY_URL|NO_PROXY_IP]
                                     Do not proxy locations for the node being bootstrapped; this option is used internally by Opscode
        --bootstrap-protocol protocol
                                     protocol to bootstrap windows servers. options: winrm/ssh
        --bootstrap-proxy PROXY_URL  The proxy server for the node being bootstrapped
        --bootstrap-template TEMPLATE
                                     Bootstrap Chef using a built-in or custom template. Set to the full path of an erb template or use one of the built-in templates.
        --bootstrap-url URL          URL to a custom installation script
        --bootstrap-vault-file VAULT_FILE
                                     A JSON file with a list of vault(s) and item(s) to be updated
        --bootstrap-vault-item VAULT_ITEM
                                     A single vault and item to update as "vault:item"
        --bootstrap-vault-json VAULT_JSON
                                     A JSON string with the vault(s) and item(s) to be updated
        --bootstrap-version VERSION  The version of Chef to install
        --bootstrap-wget-options OPTIONS
                                     Add options to wget when installing chef-client
        --ca-trust-file CA_TRUST_FILE
                                     The Certificate Authority (CA) trust file used for SSL transport
    -N, --node-name NAME             The Chef node name for your new node
        --server-url URL             Chef Server URL
        --chef-zero-host HOST        Host to start chef-zero on
        --chef-zero-port PORT        Port (or port range) to start chef-zero on.  Port ranges like 1000,1010 or 8889-9999 will try all given ports until one works.
        --classic-link-vpc-id VPC_ID Enable ClassicLink connection with a VPC
        --classic-link-vpc-security-groups-ids X,Y,Z
                                     Comma-separated list of security group ids for ClassicLink
    -k, --key KEY                    API Client Key
        --[no-]color                 Use colored output, defaults to enabled
    -c, --config CONFIG              The configuration file to use
        --config-option OPTION=VALUE Override a single configuration option
        --[no-]create-ssl-listener   Create ssl listener, enabled by default.
        --dedicated_instance         Launch as a Dedicated instance (VPC ONLY)
        --defaults                   Accept default values for all questions
        --disable-api-termination    Disable termination of the instance using the Amazon EC2 console, CLI and API.
        --disable-editing            Do not open EDITOR, just accept the data as is
    -d, --distro DISTRO              Bootstrap a distro using a template. [DEPRECATED] Use --bootstrap-template option instead.
        --ebs-encrypted              Enables EBS volume encryption
        --ebs-no-delete-on-term      Do not delete EBS volume on instance termination
        --ebs-optimized              Enabled optimized EBS I/O
        --provisioned-iops IOPS      IOPS rate, only used when ebs volume type is 'io1'
        --ebs-size SIZE              The size of the EBS volume in GB, for EBS-backed instances
        --ebs-volume-type TYPE       Standard or Provisioned (io1) IOPS or General Purpose (gp2)
    -e, --editor EDITOR              Set the editor to use for interactive commands
    -s                               The secret key to use to decrypt data bag item values. Will be rendered on the node at c:/chef/encrypted_data_bag_secret and set in the rendered client config.
    -E, --environment ENVIRONMENT    Set the Chef environment (except for in searches, where this will be flagrantly ignored)
        --ephemeral EPHEMERAL_DEVICES
                                     Comma separated list of device locations (eg - /dev/sdb) to map ephemeral devices
        --[no-]fips                  Enable fips mode
    -j JSON_ATTRIBS,                 A JSON string to be added to the first run of chef-client
        --json-attributes
        --json-attribute-file FILE   A JSON file to be used to the first run of chef-client
    -f, --flavor FLAVOR              The flavor of server (m1.small, m1.medium, etc)
    -F, --format FORMAT              Which format to use for output
    -A, --forward-agent              Enable SSH agent forwarding
        --fqdn FQDN                  Pre-defined FQDN
        --hint HINT_NAME[=HINT_FILE] Specify Ohai Hint to be set on the bootstrap target.  Use multiple --hint options to specify multiple hints.
        --[no-]host-key-verify       Verify host key, enabled by default.
        --iam-profile NAME           The IAM instance profile to apply to this instance.
    -i IDENTITY_FILE,                The SSH identity file used for authentication
        --identity-file
    -I, --image IMAGE                The AMI for the server
        --install-as-service         Install chef-client as a Windows service
        --keytab-file KEYTAB_FILE    The Kerberos keytab file used for authentication
    -R KERBEROS_REALM,               The Kerberos realm used for authentication
        --kerberos-realm
        --kerberos-service KERBEROS_SERVICE
                                     The Kerberos service used for authentication
        --[no-]listen                Whether a local mode (-z) server binds to a port
    -z, --local-mode                 Point knife commands at local repository instead of server
        --msi-url URL                Location of the Chef Client MSI. The default templates will prefer to download from this location. The MSI will be downloaded from chef.io if not provided.
    -n ENI1,ENI2,                    Attach additional network interfaces during bootstrap
        --attach-network-interface
    -u, --user USER                  API Client Username
        --node-ssl-verify-mode [peer|none]
                                     Whether or not to verify the SSL cert for all HTTPS requests.
        --[no-]node-verify-api-cert  Verify the SSL cert for HTTPS requests to the Chef server API.
        --placement-group PLACEMENT_GROUP
                                     The placement group to place a cluster compute instance
        --policy-group POLICY_GROUP  Policy group name to use (--policy-name must also be given)
        --policy-name POLICY_NAME    Policyfile name to use (--policy-group must also be given)
        --prerelease                 Install the pre-release chef gems
        --print-after                Show the data after a destructive operation
        --private-ip-address IP-ADDRESS
                                     allows to specify the private IP address of the instance in VPC mode
        --region REGION              Your AWS region
    -r, --run-list RUN_LIST          Comma separated list of roles/recipes to apply
        --s3-secret S3_SECRET_URL    S3 URL (e.g. s3://bucket/file) for the encrypted_data_bag_secret_file
        --secret                     The secret key to use to encrypt data bag item values
        --secret-file SECRET_FILE    A file containing the secret key to use to encrypt data bag item values
    -g, --security-group-ids 'X,Y,Z' The security group ids for this server; required when using VPC,Please provide values in format --security-group-ids 'X,Y,Z'
    -G, --groups X,Y,Z               The security groups for this server; not allowed when using VPC
    -a ATTRIBUTE,                    The EC2 server attribute to use for the SSH connection if necessary, e.g. public_ip_address or private_ip_address.
        --server-connect-attribute
        --session-timeout Minutes    The timeout for the client for the maximum length of the WinRM session
        --spot-price PRICE           The maximum hourly USD price for the instance
        --spot-request-type TYPE     The Spot Instance request type. Possible values are 'one-time' and 'persistent', default value is 'one-time'
        --spot-wait-mode MODE        Whether we should wait for spot request fulfillment. Could be 'wait', 'exit', or 'prompt' (default). For any of the above mentioned choices, ('wait') - if the instance does not get allocated before the command itself times-out or ('exit') the user needs to manually bootstrap the instance in the future after it gets allocated.
    -w, --ssh-gateway GATEWAY        The ssh gateway server. Any proxies configured in your ssh config are automatically used by default.
        --ssh-gateway-identity IDENTITY_FILE
                                     The private key for ssh gateway server
    -S, --ssh-key KEY                The AWS SSH key id
        --ssh-password PASSWORD      The ssh password
        --ssh-port PORT              The ssh port
        --ssh-user USERNAME          The ssh username
        --ssl-peer-fingerprint FINGERPRINT
                                     ssl Cert Fingerprint to bypass normal cert chain checks
        --subnet SUBNET-ID           create node in this Virtual Private Cloud Subnet ID (implies VPC mode)
    -T Tag=Value[,Tag=Value...],     The tags for this server
        --tags
        --template-file TEMPLATE     Full path to location of template to use. [DEPRECATED] Use -t / --bootstrap-template option instead.
        --use-iam-profile            Use IAM profile assigned to current machine
        --use-sudo-password          Execute the bootstrap via sudo with password
        --validation-key-url URL     Path to the validation key
    -V, --verbose                    More verbose output. Use twice for max verbosity
    -v, --version                    Show chef version
        --winrm-authentication-protocol AUTHENTICATION_PROTOCOL
                                     The authentication protocol used during WinRM communication. The supported protocols are basic,negotiate,kerberos. Default is 'negotiate'.
    -P, --winrm-password PASSWORD    The WinRM password
    -p, --winrm-port PORT            The WinRM port, by default this is '5985' for 'plaintext' and '5986' for 'ssl' winrm transport
        --winrm-ssl-verify-mode SSL_VERIFY_MODE
                                     The WinRM peer verification mode. Valid choices are [verify_peer, verify_none]
    -t, --winrm-transport TRANSPORT  The WinRM transport type. Valid choices are [ssl, plaintext]
    -x, --winrm-user USERNAME        The WinRM username
    -y, --yes                        Say yes to all prompts for confirmation
    -h, --help                       Show this message
```
