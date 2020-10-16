import subprocess
import schedule
import time

render_interval_in_minutes = 15
cooldown_interval_in_seconds = 30

print(subprocess.run(["ls", "-lah"]))

def run_renderer():
    print("Running renderer..")
    res = subprocess.run(["./overviewer.py", "--rendermodes=smooth-lighting", "-p2", "/world", "/cache"])
    print("Got status code:", res.returncode)

print("Running renderer once immediately and then scheduling a run every", render_interval_in_minutes, "minutes..")
run_renderer()
schedule.every(render_interval_in_minutes).minutes.do(run_renderer)

while(True):
    schedule.run_pending()
    print("No job scheduled. Sleeping for", cooldown_interval_in_seconds, "seconds..")
    time.sleep(cooldown_interval_in_seconds)
