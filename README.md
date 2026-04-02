# CS/ECE 354 Project Fetcher

A small Bash utility for copying UW–Madison CS/ECE 354 project directories from the
CS Linux machines to your local machine using `scp`. This is useful for
local development (which is how I preferred to work).
I used AI in the development of this project.

---

## One-time Setup

1. Copy the example config file:
   ```bash
   cp fetch.conf.example fetch.conf
   ```

2. Edit `fetch.conf` and set your information:
   ```bash
   CSUSER="your_cs_username"
   INSTRUCTOR="your_instructor_last_name"
   ```

3. Make the script executable (once):
   ```bash
   chmod +x fetch.sh
   ```

---

## Usage

### Interactive Mode

Run the script with no arguments.  
You will be prompted for the project number, and the directory will be copied
into the current working directory.

```bash
./fetch.sh
```

Example:
```
Enter project number: 5
```

Result:
```
./p5/
```

---

### Non-interactive Mode

Provide the project number and an output directory using `-o`.

```bash
./fetch.sh <project> -o <destination>
```

Example:
```bash
./fetch.sh 5 -o ~/cs354/p5
```

The destination directory will be created automatically if it does not exist.

---

### Help

You can view usage information at any time with:

```bash
./fetch.sh -h
./fetch.sh --help
```

---
