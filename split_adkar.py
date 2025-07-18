#!/usr/bin/env python3
import json

# Read the original adkar.json file
with open('lib/core/data/json/adkar.json', 'r', encoding='utf-8') as f:
    all_adkar = json.load(f)

# Categories to split
categories = {
    "أذكار الصباح": [],
    "أذكار المساء": [],
    "أذكار النوم": [],
    "أذكار الاستيقاظ من النوم": [],
    "other": []
}

# Split by category
for adkar in all_adkar:
    category = adkar.get("category", "")
    if category in categories:
        categories[category].append(adkar)
    else:
        categories["other"].append(adkar)

# Write separate JSON files
json_files = {
    "أذكار الصباح": "lib/core/data/json/adhkar_sabah.json",
    "أذكار المساء": "lib/core/data/json/adhkar_massa.json", 
    "أذكار النوم": "lib/core/data/json/adhkar_nawm.json",
    "أذكار الاستيقاظ من النوم": "lib/core/data/json/adhkar_istiqadh.json",
    "other": "lib/core/data/json/adhkar_other.json"
}

for category, filepath in json_files.items():
    if categories[category]:  # Only write if there are items
        with open(filepath, 'w', encoding='utf-8') as f:
            json.dump(categories[category], f, ensure_ascii=False, indent=4)
        print(f"Created {filepath} with {len(categories[category])} items")

print("\nCategory counts:")
for category, items in categories.items():
    print(f"{category}: {len(items)} items")
