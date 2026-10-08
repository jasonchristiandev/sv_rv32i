import glob
import os
import subprocess
import sys
from pathlib import Path

SRCS = "src/*.sv"
TESTS = "tests/*.sv"
PCF = "pins.pcf"

BUILD_DIR = Path("build")
SIM_BIN = BUILD_DIR / "sim.out"
JSON = BUILD_DIR / "main.json"
ASC = BUILD_DIR / "routed.asc"
ROUTED_JSON = BUILD_DIR / "routed.json"
YS_SCRIPT = BUILD_DIR / "synth.ys"

def build_dir():
	BUILD_DIR.mkdir(parents=True, exist_ok=True)

def run_cmd(cmd):
	print(f"{sys.argv[0]}: $ {" ".join(cmd)}")
	res = subprocess.run(cmd)
	if res.returncode != 0:
		print(f"{sys.argv[0]} command failed with exit code {res.returncode}")
		sys.exit(res.returncode)

def sim():
	build_dir()
	run_cmd(["iverilog", "-g2012", "-s", "master_tb", "-I", "./include", "-o", str(SIM_BIN)] + glob.glob(SRCS) + glob.glob(TESTS))
	run_cmd(["vvp", str(SIM_BIN)])

def wave():
	vcd_file = BUILD_DIR / "wave.vcd"

	if not vcd_file.exists():
		sim()
	if not vcd_file.exists():
		print(f"{sys.argv[0]}: simulation doesnt output {vcd_file}")
		sys.exit(1)
	run_cmd(["gtkwave", str(vcd_file)])

def synth():
	build_dir()

	src_files = [f.replace("\\", "/") for f in glob.glob(SRCS)]
	json_path = str(JSON).replace("\\", "/")

	ys_content = [
		f"read_verilog -I include -sv {" ".join(src_files)}",
		"hierarchy -top rv32i",
		"synth_ice40",
		f"write_json {json_path}"
	]
	YS_SCRIPT.write_text("\n".join(ys_content))

	run_cmd(["yosys", "-s", str(YS_SCRIPT)])

	pnr_cmd = [
		"nextpnr-ice40",
		"--hx8k",
		"--package", "ct256",
		"--top", "rv32i",
		"--json", str(JSON),
		"--pcf", PCF,
		"--asc", str(ASC),
		"--write", str(ROUTED_JSON)
	]
	run_cmd(pnr_cmd)

def gui():
	if not ROUTED_JSON.exists():
		synth()
	run_cmd([
		"nextpnr-ice40",
		"--hx8k",
		"--package", "ct256",
		"--top", "top",
		"--json", str(ROUTED_JSON),
		"--gui"
	])

TARGETS = {
	"--sim": sim,
	"--wave": wave,
	"--synth": synth,
	"--gui": gui,
}

if __name__ == "__main__":
	if len(sys.argv) < 2:
		print(f"Usage: {sys.argv[0]} [--sim] [--wave [tb_name]] [--synth] [--gui]")
		sys.exit(1)

	args = sys.argv[1:]
	i = 0

	while i < len(args):
		arg = args[i].lower()
		
		if arg not in TARGETS:
			print(f"{sys.argv[0]}: unknown target '{args[i]}'")
			sys.exit(1)

		TARGETS[arg]()

		i += 1
