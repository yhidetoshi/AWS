require 'aws-sdk-core'

  ec2 = Aws::EC2::Client.new
  instanceID = 'i-06a861ed7a1685e8f'

  begin
    ec2.start_instances(instance_ids: [instanceID])
    ec2.wait_until(:instance_running, instance_ids:[instanceID])
    puts "Instance is Running"
  rescue Aws::Waiters::Errors::WaiterFailed => error
    puts "failed waiting for Instance Running: #{error.message}"
  end

