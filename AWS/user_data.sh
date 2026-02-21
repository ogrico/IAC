#!/bin/bash
# User data script for EC2 instance initialization
set -e

# Update system packages
yum update -y

# Install Apache web server
yum install -y httpd

# Get instance metadata
INSTANCE_ID=$(ec2-metadata --instance-id | cut -d " " -f 2)
INSTANCE_TYPE=$(ec2-metadata --instance-type | cut -d " " -f 2)
AVAIL_ZONE=$(ec2-metadata --availability-zone | cut -d " " -f 2)

# Create a welcome page
cat > /var/www/html/index.html << 'HTMLEOF'
<!DOCTYPE html>
<html>
<head>
    <title>EC2 Instance - AWS</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { 
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }
        .container {
            background: white;
            border-radius: 10px;
            box-shadow: 0 10px 40px rgba(0,0,0,0.2);
            padding: 40px;
            max-width: 600px;
            text-align: center;
        }
        h1 { 
            color: #232f3e;
            margin-bottom: 20px;
            font-size: 32px;
        }
        .success {
            color: #28a745;
            font-size: 48px;
            margin-bottom: 20px;
        }
        .info-box {
            background: #f8f9fa;
            border-left: 4px solid #667eea;
            padding: 15px;
            margin: 15px 0;
            text-align: left;
            border-radius: 5px;
        }
        .label {
            font-weight: bold;
            color: #232f3e;
        }
        .value {
            color: #667eea;
            font-family: monospace;
            margin-top: 5px;
        }
        .aws-logo {
            font-size: 48px;
            margin-bottom: 20px;
        }
        footer {
            margin-top: 40px;
            padding-top: 20px;
            border-top: 1px solid #ddd;
            color: #666;
            font-size: 14px;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="aws-logo">☁️</div>
        <div class="success">✓</div>
        <h1>EC2 Instance Running!</h1>
        <p style="font-size: 18px; color: #666; margin-bottom: 30px;">Your public EC2 instance deployed with Terraform is active and ready.</p>
        
        <div class="info-box">
            <div class="label">Instance ID</div>
            <div class="value" id="instance-id">Loading...</div>
        </div>
        
        <div class="info-box">
            <div class="label">Instance Type</div>
            <div class="value" id="instance-type">Loading...</div>
        </div>
        
        <div class="info-box">
            <div class="label">Availability Zone</div>
            <div class="value" id="avail-zone">Loading...</div>
        </div>
        
        <footer>
            <p>Deployed with <strong>Terraform</strong> | AWS Free Tier Eligible</p>
        </footer>
    </div>

    <script>
        // Fetch metadata from EC2 metadata service
        async function getMetadata() {
            try {
                const token = await fetch('http://169.254.169.254/latest/api/token', {
                    method: 'PUT',
                    headers: { 'X-aws-ec2-metadata-token-ttl-seconds': '21600' }
                }).then(r => r.text());

                const instanceId = await fetch('http://169.254.169.254/latest/meta-data/instance-id',
                    { headers: { 'X-aws-ec2-metadata-token': token } }).then(r => r.text());
                    
                const instanceType = await fetch('http://169.254.169.254/latest/meta-data/instance-type',
                    { headers: { 'X-aws-ec2-metadata-token': token } }).then(r => r.text());
                    
                const availZone = await fetch('http://169.254.169.254/latest/meta-data/placement/availability-zone',
                    { headers: { 'X-aws-ec2-metadata-token': token } }).then(r => r.text());

                document.getElementById('instance-id').textContent = instanceId;
                document.getElementById('instance-type').textContent = instanceType;
                document.getElementById('avail-zone').textContent = availZone;
            } catch (e) {
                console.log('Could not fetch metadata', e);
            }
        }
        
        window.addEventListener('load', getMetadata);
    </script>
</body>
</html>
HTMLEOF

# Set permissions
chown -R ec2-user:ec2-user /var/www/html

# Start and enable Apache
systemctl start httpd
systemctl enable httpd

echo "EC2 instance initialization complete!"
