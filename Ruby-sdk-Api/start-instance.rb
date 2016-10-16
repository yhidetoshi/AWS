require 'aws-sdk-core'

  ec2 = Aws::EC2::Client.new
  instanceID = 'i-06a861ed7a1685e8f'

  begin
<<<<<<< HEAD
    ec2.start_instances(instance_ids: [instanceID])
    ec2.wait_until(:instance_running, instance_ids:[instanceID])
=======
    ec2.start_instances(instance_ids: ['i-xxxxxxx'])
    ec2.wait_until(:instance_running, instance_ids:['i-xxxxxxx'])
>>>>>>> 92302d02740406f41f659de51fa11e89de37a583
    puts "Instance is Running"
  rescue Aws::Waiters::Errors::WaiterFailed => error
    puts "failed waiting for Instance Running: #{error.message}"
  end

