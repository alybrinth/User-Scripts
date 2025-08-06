UserData:
  Fn::Base64:
    !Sub |
      #!/bin/bash

      # Update and install Apache
      yum update -y
      yum install -y httpd
      systemctl start httpd
      systemctl enable httpd

      # Set timezone to IST
      timedatectl set-timezone Asia/Kolkata
      yum install -y chrony
      systemctl enable chronyd && systemctl start chronyd

      # Write Hello World + Boot Time to index.html
      echo "<h1>Hello from $(hostname -f)</h1>" > /var/www/html/index.html
      echo "<p>Launched at: $(date)</p>" >> /var/www/html/index.html

      # Create custom 404 page
      echo "<h1>Oops, not found bruh 💀</h1>" > /var/www/html/404.html

      # Add shutdown banner
      echo "echo 'Bye, hope you didn’t break production :)'" > /etc/rc0.d/K99shutdownmsg
      chmod +x /etc/rc0.d/K99shutdownmsg

      # Custom MOTD with ALY ASCII banner and loading bar
      cat << 'EOF' > /etc/profile.d/aly_motd.sh
      clear
      echo -e "\e[1;32m           d8b           \e[0m"
      echo -e "\e[1;32m           88P           \e[0m"
      echo -e "\e[1;32m          d88            \e[0m"
      echo -e "\e[1;32m d888b8b  888  ?88   d8P \e[0m"
      echo -e "\e[1;32md8P' ?88  ?88  d88   88  \e[0m"
      echo -e "\e[1;32m88b  ,88b  88b ?8(  d88  \e[0m"
      echo -e "\e[1;32m\`?88P'\`88b  88b\`?88P'?8b \e[0m"
      echo -e "\e[1;32m                      )88\e[0m"
      echo -e "\e[1;32m                     ,d8P\e[0m"
      echo -e "\e[1;32m                  \`?888P'\e[0m"
      echo ""
      echo -e "\e[1;33m        Welcome to ALY — Alybrinth Labs 🌀\e[0m"
      echo ""

      # Loading bar
      echo -ne "\e[1;32mLoading: \e[0m"
      for i in {1..20}; do
        echo -ne "#"
        sleep 0.5
      done
      echo ""
      sleep 1
      clear

      # Final output
      echo -e "\e[1;32m🌀 ALY for Alybrinth Labs — Instance Ready 🌀\e[0m"
      echo "Hostname: $(hostname -f)"
      echo "Launch Time: $(date)"
      echo ""
EOF

      chmod +x /etc/profile.d/aly_motd.sh
