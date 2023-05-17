# Base docker file

Create default base docker images so all microservice don't have to define the same settings, like not using ROOT and maybe setting certificates

Ideally the debian image is in a separate repo, and is used to create all other images. Like JDK, images to build GO, build Pyhton, ....

This would be the only image that has to be maintained by Security team in case of vulnerabilities.

A pipeline should be made that once the debian images is updated it will also update all other base docker images. 

Teams should ONLY use the docker images provided by the company.

The image used by the teams should be the one with a `rolling-tag` like stable. 

Once the security team has build new images and verified them they can re-tag those as stable.

This way teams don't have to update all the repositories. 