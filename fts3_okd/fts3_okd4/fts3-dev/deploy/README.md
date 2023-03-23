First time you initialize the DB, edit project.yaml to uncomment out:
 - name: DATABASE_UPGRADE
   value: "yes"

oc apply -f  pvc.yaml -f secrets.yaml -f imagestream.yaml -f service.yaml

Wait until the PVC is bound (oc get pvc):

oc apply -f project.yaml -f cronjobs.yaml
