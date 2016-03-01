# Installing guide #
This guide explains how to prepare your OS to run the project medcodeassist of EONUM.

## Linux (Ubuntu) ##
** Tested on Ubuntu 14.04 LTS **

#### Install Ruby 2.2.1, Rails 4.2, RVM, Git, ... ####

* Download mpapis public key: ``` gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 ```
* Install Curl: ``` sudo apt-get install curl ```
* Install ruby version manager (RVM) with rails: ```\curl -sSL https://get.rvm.io | bash -s stable --rails```
* Install git: ``` sudo apt-get install git ```

#### Clone the git repository medcodeassist ####
* Change to the directory where you want to clone the project.
* Clone the repo: ``` git clone https://github.com/eonum/medcodeassist.git ```

#### Install the gems ####
* Make sure to run the terminal as a login-shell (Edit->Profiles->Edit->Title and Command->run command as a login shell)
* Open a new bash
* Change to your cloned directory: ```cd medcodeassist ```
* Create a project-specific gemset: ``` rvm use ruby-2.2.1@medcodeassist --ruby-version --create ```
* Install the bundle: ``` bundle install ```

#### Create the secrets.yml file ####
* In bash type: ``` nano  config/secrets.yml```
* Enter the following code and replace "xx...x" with 3 different outputs of ``` rake secret ```:

\# Be sure to restart your server when you modify this file...
<br>
\# Make sure the secret is at least 30 characters and all random,
<br>
\# No regular words or you'll be exposed to dictionary attacks.
<br>
development:
<br>
&nbsp;&nbsp;secret_key_base: xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
<br>
test:
<br>
&nbsp;&nbsp;secret_key_base: xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
<br>
production:
<br>
&nbsp;&nbsp;secret_key_base: <%= ENV["SECRET_KEY_BASE"] %>

* Store with ``` ctrl + o ``` then exit with ``` ctrl + x ```

#### Run the rails server ####
* To run the server at port 3000, type: ``` bin/rails server -p 3000```
* Open your favorite browser and go to: ``` localhost:3000 ```

## Windows & Mac##
** Tested on Windows 7 **

| NOTE                                                   |
| : ---------------------------------------------------- |
| This is not the best solution but one of the quickest. |
| Not tested on Mac.                                    |

#### Install Ruby 2.2, Rails 4.2, Git, ... ####

* Download railsinstaller for ruby 2.2 <a href="http://railsinstaller.org">here<a>
* Leave all checkboxes checked.

#### Clone the git repository medcodeassist ####
* Open git bash
* Change to the directory where you want to clone the project.
* Clone the repo: ``` git clone https://github.com/eonum/medcodeassist.git ```

#### Install the gems ####
* Change to your cloned directory: ```cd medcodeassist ```
* Install missing gems: ``` bundle install ```
* ***Here is still a problem, the server won't start!***

#### Create the secrets.yml file ####
* In git bash type: ``` nano  config/secrets.yml```
* Enter the following code and replace "xx...x" with 3 different outputs of ``` rake secret ```:

\# Be sure to restart your server when you modify this file...
<br>
\# Make sure the secret is at least 30 characters and all random,
<br>
\# No regular words or you'll be exposed to dictionary attacks.
<br>
development:
<br>
&nbsp;&nbsp;secret_key_base: xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
<br>
test:
<br>
&nbsp;&nbsp;secret_key_base: xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
<br>
production:
<br>
&nbsp;&nbsp;secret_key_base: <%= ENV["SECRET_KEY_BASE"] %>

* Store with ``` ctrl + o ``` then exit with ``` ctrl + x ```

#### Run the rails server ####
* To run the server at port 3000, type: ``` bin/rails server -p 3000```
* Open your favorite browser and go to: ``` localhost:3000 ```
