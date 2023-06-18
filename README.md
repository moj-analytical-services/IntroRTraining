# Introduction to R Training

This is the repository for the Introduction to R training course, which aims to get participants up and running with using R on the MoJ's Analytical Platform. If you haven't yet used the Analytical Platform (AP), there is a prerequisite course that gives an [introduction to using R on the Analytical Platform](https://github.com/moj-analytical-services/intro_using_r_on_ap).

If you are taking this Introduction to R course you will find the following documents useful:

* Intro_markdown.html - this document provides accompanying training material used in the Introduction to R Training session
* code_participant.R - this script contains the code used in the training session

The Intro_markdown.html file can be viewed in a web browser after cloning this repo into RStudio on the AP, or downloading the contents locally using the green "Code" button on GitHub, and then clicking "Download ZIP".

In advance of the training session please follow these setup steps:

 - If you do not already have an account on the Analytical Platform. following these instructions to sign up for one: https://user-guidance.services.alpha.mojanalytics.xyz/get-started.html
 - If you're using RStudio on the Analytical Platform for the first time, you will first need to deploy it: https://user-guidance.services.alpha.mojanalytics.xyz/tools/control-panel.html
 - Open RStudio from your Analytical Platform control panel: https://user-guidance.services.alpha.mojanalytics.xyz/tools/control-panel.html
 - If you've not used Git/GitHub with you RStudio account before, follow these steps to connect your RStudio to your GitHub account: https://user-guidance.analytical-platform.service.justice.gov.uk/github/rstudio-git.html#work-with-git-in-rstudio
 - Clone this GitHub repository by following the same process as here, but using the course's repo:
 https://user-guidance.analytical-platform.service.justice.gov.uk/tools/create-a-derived-table/instructions/#clone-the-repository-using-the-rstudio-gui
 - In the Console window in RStudio, enter this command to make sure you have the required packages installed: `renv::restore()`
 - Request access to the alpha-r-training bucket on Amazon S3 (which is used to store some example data) from the session organisers or by posting on the #intro_r channel on ASD Slack. To check if you can access the bucket you can run the following code in the RStudio Console, which should output a list of files stored in the bucket: `botor::s3_ls('s3://alpha-r-training')`

This training session is run in person/over Teams every few months. Alternatively, you can go through this material in your own time - all course material is included in the document [Intro_markdown.html](https://github.com/moj-analytical-services/IntroRTraining/blob/master/Intro_markdown.html), which you can find listed above, and you can find recordings of previous sessions [here](https://web.microsoftstream.com/channel/aa3cda5d-99d6-4e9d-ac5e-6548dd55f52a). If you work through the material by yourself please leave feedback about the material [here](https://airtable.com/shr9u2OJB2pW8Y0Af)  

Please contact [Georgina Eaton](Georgina.Eaton4@Justice.gov.uk) if you have any questions.
