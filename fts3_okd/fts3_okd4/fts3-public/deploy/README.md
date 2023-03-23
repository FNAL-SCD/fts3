How to import the backup files
===============================

These are the instructions to create a new application by importing the existing yaml files. For obvious security reasons, please notice that none of the secrets are exposed here, neither the references in the corresponding configuration files to create them.
The best practices and the importants steps to deal with the secrets will be in our internal operations documentation. Once you have them:

If it's the first time you initialize the DB, edit project.yaml to uncomment out:

 - name: DATABASE_UPGRADE
   value: "yes"

Now, to import the project:

```
oc apply -f  pvc.yaml -f secrets.yaml -f imagestream.yaml -f service.yaml
```

You have to wait until the PVC is bound (oc get pvc):

```
oc apply -f project.yaml -f cronjobs.yaml
```
