echo "Welcome!"

# Tell a fortune with a random cow
fortune | cowsay -f `ls /usr/share/cowsay/cows/ | shuf -n 1`
