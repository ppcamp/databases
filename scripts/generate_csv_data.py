import csv
import random
import string

filename = "large_file.csv"
num_rows = 1_000_000  # adjust if needed

# Some sample values
names = ["Alice", "Bob", "Charlie", "David", "Eve", "Frank"]
cities = ["New York", "London", "Paris", "Berlin", "Tokyo"]

with open(filename, "w", newline="") as csvfile:
    writer = csv.writer(csvfile)
    # Write header
    writer.writerow(["id", "name", "age", "score", "city"])

    for i in range(1, num_rows + 1):
        row = [
            i,
            random.choice(names),
            random.randint(18, 80),
            round(random.uniform(0, 100), 2),
            random.choice(cities),
        ]
        writer.writerow(row)

print(f"CSV '{filename}' generated!")
