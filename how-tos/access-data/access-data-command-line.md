---
title: How do I access data stored in Earthdata Cloud with cURL and Wget?
---

[How To Access Data With cURL And Wget](https://urs.earthdata.nasa.gov/documentation/for_users/data_access/curl_and_wget) provides an step-by-step instruction on how to bulk download data from NASA EOSDIS DAACs using [wget](https://www.gnu.org/software/wget/) and  [cURL](https://curl.se/) from the command line. 

This section provides additional recommendations relevant to bulk downloading data using wget/cURL. The existing documentation will be updated with these additional notes in future. 
- You need to [install wget](https://ftp.gnu.org/gnu/wget/) or [install cURL](https://curl.se/download.html) before diving into this documentation. 
  - View [installing curl instructions](https://developer.zendesk.com/documentation/api-basics/getting-started/installing-and-using-curl/#installing-curl) and [Frequently Asked Questions About Downloading GNU Wget](http://wget.addictivecode.org/FrequentlyAskedQuestions.html#download) for more details.
- You also need to save download link(s) for your data as a text file using [Nasa Earthdata Search](https://search.earthdata.nasa.gov/search) or [Common Metadata Repository (CMR)](https://www.earthdata.nasa.gov/eosdis/science-system-description/eosdis-components/cmr) API.
- Navigate to the directory you want to save the data using `cd Insert_Your_Directory`.
- To bulk download multiple files using cURL try:
    ```text
    xargs -n 1 curl -O -b ~/.urs_cookies -c ~/.urs_cookies -L -n < Insert_Text_File
    ```
- If you experience authentication issues working with wget, try creating .wgetrc file  in your home directory/user profile as suggested in [Troubleshooting wget](https://urs.earthdata.nasa.gov/documentation/for_users/data_access/troubleshooting_wget).
  
  To Create a .wgetrc file in the command line, enter the following in Terminal.  
  - Windows  
    ```text
    NUL >> .wgetrc  
    ```
  - MacOS or Linux  
    ```text
    touch .wgetrc | chmod og-rw .wgetrc
    ```
  To insert your NASA Earthdata Login username and password into the file, enter the following in the Command Prompt and replace your username and password.  
  
  ```text
  echo http-user=Insert_Your_Username >> .wgetrc | echo http-password=Insert_Your_Password >> .wgetrc
  ```
  After creating .wgetrc file in your home directory/user profile, for downloading a single file try:
  ```text
    wget Insert_the_Download_Link
    ``` 
  For downloading multiple files try:
   ```text
    wget -i Insert_Text_File
    ``` 

