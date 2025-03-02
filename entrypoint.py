import os
import subprocess

def run_command(command):
    result = subprocess.run(command, shell=True, check=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    return result.stdout.decode('utf-8').strip()

def main():
    bw_host = os.getenv('BW_HOST')
    bw_user = os.getenv('BW_USER')

    run_command(f'bw config server {bw_host}')

    bw_session = run_command(f'bw login {bw_user} --passwordenv BW_PASSWORD --raw')
    os.environ['BW_SESSION'] = bw_session

    run_command('bw unlock --check')

    print('Running `bw server` on port 8087')
    run_command('bw serve --hostname 0.0.0.0')  # --disable-origin-protection

if __name__ == '__main__':
    main()
