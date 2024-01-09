echo "init.sh: Starting"
# if secrets.yaml does not exist, copy secrets-example.yaml to secrets.yaml
if [ ! -f "secrets.yaml" ] && [ -f "secrets-example.yaml" ]; then
    echo "Copying secrets-example.yaml to secrets.yaml"
    cp secrets-example.yaml secrets.yaml
fi
echo "init.sh: Complete"
