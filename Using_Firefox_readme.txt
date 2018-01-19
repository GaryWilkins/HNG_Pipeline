Longleaf is poorly suited for graphics/internet browser work, but the Research Computing group has made improvements

The required libraries are already installed so all that's necessary to use Firefox is to grab the source and install to the location of your choice.

1) Open a terminal and go to your home directory using the following command: 
cd ~

For your convenience, the source named firefox-57.0.4.tar.bz2 is located in the hng_pipeline directory, /proj/hng/hng_pipeline

2) Copy this source from the hng pipeline directory to your home directory using the following command:
cp /proj/hng/hng_pipeline/firefox-57.0.4.tar.bz2 /your/directory/

3) Extract the contents of the firefox file using the following command:
tar xjf firefox-*.tar.bz2

4) You will also need to make changes to your .bash_profile file:
Add the following line: alias firefox=~/firefox/firefox
