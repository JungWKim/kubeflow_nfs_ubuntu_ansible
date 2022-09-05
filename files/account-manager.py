import subprocess, bcrypt, os, readline, time

def usage():
    print("\n\n  User")
    print("   a   add user")
    print("   d   delete user")
    print("\n  Exit")
    print("   q   exit this program")

def profile():
    email = input("email : ")
    password = input("passwd : ")
    username = input("username : ")
    hash_password = bcrypt.hashpw(password.encode('utf-8'), bcrypt.gensalt(rounds=10)).decode("ascii")

    cmd = "sed -i -r -e '/staticPasswords/a\\    \- email: " + email + "\\n\     \ hash: " + hash_password + "\\n\     \ username: " + username + "\\n\     \ userID: " + username + "' /home/gpuadmin/manifests/common/dex/base/config-map.yaml"

# insert profile.yaml - chun
    profile = open("/home/gpuadmin/profile.yaml",'a')
    profile.write("---\n")
    profile.write("apiVersion: kubeflow.org/v1beta1\n")
    profile.write("kind: Profile\n")
    profile.write("metadata:\n")
    profile.write("  name: " + username + "\n")
    profile.write("spec:\n")
    profile.write("  owner:\n")
    profile.write("    kind: User\n")
    profile.write("    name: " + email + "\n")
    profile.close
    subprocess.call(cmd, shell=True)

def useradd():

# jungwoo edit script
    subprocess.call("while ! kustomize build /home/gpuadmin/manifests/example | kubectl apply -f -; do echo ""Retrying to apply resources""; sleep 10; done", shell=True)
    subprocess.call("kubectl -n auth rollout restart deployment dex", shell=True)
    subprocess.call("kubectl apply -f /home/gpuadmin/profile.yaml", shell=True)

def userdel():
    email = input("Delete User Email : ")
    user = input("Delete Namespace(user) : ")
    cmd1 = "sed -i '/" + email + "/,+3 d' /home/gpuadmin/manifests/common/dex/base/config-map.yaml"

# delete profile.yaml - chun
    cmd3 = "grep -n " + email + " /home/gpuadmin/profile.yaml | cut -d: -f1"
    result = int(os.popen(cmd3).read())
    result_start = result - 8
    cmd4 = "sed -i '" + str(result_start) + "," + str(result) + " d' /home/gpuadmin/profile.yaml"
    subprocess.call(cmd4, shell=True)


# jungwoo edit script
    subprocess.call(cmd1, shell=True)

    subprocess.call("kubectl delete profile " + user, shell=True)
    subprocess.call("kubectl delete ns " + user, shell=True)

    subprocess.call("while ! kustomize build /home/gpuadmin/manifests/example | kubectl apply -f -; do echo ""Retrying to apply resources""; sleep 10; done", shell=True)
    subprocess.call("kubectl -n auth rollout restart deployment dex", shell=True)


def main():
    while True:
        print("\n\n----- Welcome to kubeflow account manager -----\n\n")
        operation = input("Command (m for help): ")
        if operation == "m":
            usage()
        elif operation == "a":
            profile()
            useradd()
        elif operation == "d":
            userdel()
        elif operation == "q":
            quit()

if __name__=="__main__":
    main()
