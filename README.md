# Introduction to R Training

If you are taking the introductory R training you will find the following documents useful:

* Intro_markdown.docx - this document provides accompanying training material used in the Introduction to R Training session
* code_participant.R - this script contains the code used in the training session

In advance of the training session please follow the these setup steps:

 - If you do not already have an account on the Analytical Platform. following these instructions to sign up for one: https://user-guidance.services.alpha.mojanalytics.xyz/introduction.html#get-started
 - If you're using RStudio on the Analytical Platform for the first time, follow these steps to deploy it: https://user-guidance.services.alpha.mojanalytics.xyz/introduction.html#deploy-analytical-tools
 - Open RStudio from your Analytical Platform control panel: https://user-guidance.services.alpha.mojanalytics.xyz/introduction.html#open-analytical-tools
 - If you've not used Git/GitHub with you RStudio account before, follow these steps to connect your RStudio to your GitHub account: https://user-guidance.services.alpha.mojanalytics.xyz/introduction.html#configure-git-and-github
 - Clone this GitHub repository by following step 1 here: https://user-guidance.services.alpha.mojanalytics.xyz/github.html#step-1-navigate-to-your-platform-r-studio-and-make-a-copy-of-the-github-project-in-your-r-studio
 - In the Console window in RStudio, enter this command to make sure you have the required packages installed: `renv::restore()`
 - Request access to the alpha-r-training bucket on Amazon S3 (which is used to store some example data) from the session organisers. To check if you can access the bucket you can run the following code in the RStudio Console, which should output a list of files stored in the bucket: `botor::s3_ls('s3://alpha-r-training')`

This training session is run in person/over Teams every few months. Alternatively, you can go through this material in your own time - you can find recordings of a previous session [here](https://web.microsoftstream.com/channel/aa3cda5d-99d6-4e9d-ac5e-6548dd55f52a). See [Remote learning](#remote-learning) for more tips on going through this material in your own time. If you work through the material by yourself please leave feedback about the material [here](https://airtable.com/shr9u2OJB2pW8Y0Af)  

Please contact [George Papadopoulos](George.papadopoulos@Justice.gov.uk) if you have any questions.
