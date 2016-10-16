require 'aws-sdk-core'

  ec2 = Aws::EC2::Client.new

  begin
    ec2.start_instances(instance_ids: ['i-xxxxxxx'])
    ec2.wait_until(:instance_running, instance_ids:['i-xxxxxxx'])
    puts "Instance is Running"
  rescue Aws::Waiters::Errors::WaiterFailed => error
    puts "failed waiting for Instance Running: #{error.message}"
  end

