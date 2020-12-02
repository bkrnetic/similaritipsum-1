# How to set up local development environment (macOS) #  
  
- Install docker [Link](https://docs.docker.com/docker-for-mac/install/)  
- Install docker-compose ```brew install docker-compose```  
- Click on Docker whale icon, open Preferences, Resources, File Sharing. With + button add project folder to Docker resources, and press Apply & Restart.  
  
# How to set up local development environment (Windows) #  
- Install docker for Windows [Link]([https://hub.docker.com/editions/community/docker-ce-desktop-windows/])  
- Install cygwin [Link](https://cygwin.com/setup-x86_64.exe)  
- During cygwin setup follow these steps:  
  1. When asked "Choose a download source", select "Install from Internet"  
  2. Install for All Users  
  3. Choose default selections on next steps  
  4. Choose first download site from list  
  5. On Select Packages screen, under View choose Not Installed, scroll down and find make package.   
    Double click on Skip under New column, and latest version would be selected. Click Next.  
  6. On review and confirm changes, click Next.  
- Double click on cygwin icon and open terminal. Disk "C" is mapped under /cygdrive/c and if you want to go inside project   
folder which is placed i.e. on Desktop of User Windows user, type `cd /cygdrive/c/User/Desktop/ProjectFolder`.  
From that folder you can manage and use local development environment.

# Step 2: 

- Go inside project folder and issue command ```make build```. It will build docker images for this project.

# Step 3:
- After images are built, you can start your environment. Command for that is
 ```make start```

# Step 4:
- After all containers are up (no additional docker output is thrown in console), open another terminal session.   
    Go to project folder and issue command ```make setup``` which will execute   
    post-install steps

- Execute command ```make stop``` when you want to stop your development environment.

# Step 5:
- Use application API on http://localhost:8080/api/v1/s1/filename1/s2/filename2
- Replace filename1 and filename2 with available lorem ipsum text filenames below
- Available lorem ipsum : baconipsum,loremipsum,cupcakeipsum,pirateipsum
- You can combine any of available lorem ipsum texts to get similarity between them