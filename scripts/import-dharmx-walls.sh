#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
WALL_DIR="${REPO_ROOT}/wallpapers"
LIST_FILE="${REPO_ROOT}/wallpapers/sources/dharmx-categories.txt"
TMP_DIR="$(mktemp -d)"
PER_CATEGORY="${PER_CATEGORY:-4}"

cleanup() {
  rm -rf "${TMP_DIR}"
}
trap cleanup EXIT

if ! command -v git >/dev/null 2>&1; then
  echo "git is required"
  exit 1
fi

if ! command -v shuf >/dev/null 2>&1; then
  echo "shuf is required (coreutils)"
  exit 1
fi

if [[ ! -f "${LIST_FILE}" ]]; then
  echo "Missing category list: ${LIST_FILE}"
  exit 1
fi

echo "Cloning dharmx/walls (sparse)..."
git clone --depth=1 --filter=blob:none --sparse "https://github.com/dharmx/walls.git" "${TMP_DIR}/walls" >/dev/null

cd "${TMP_DIR}/walls"

mapfile -t CATEGORIES < <(rg -v '^\s*(#|$)' "${LIST_FILE}" || true)
if [[ "${#CATEGORIES[@]}" -eq 0 ]]; then
  echo "No categories configured in ${LIST_FILE}"
  exit 1
fi

git sparse-checkout set "${CATEGORIES[@]}"

echo "Importing up to ${PER_CATEGORY} wallpapers per category..."
mkdir -p "${WALL_DIR}"

for category in "${CATEGORIES[@]}"; do
  src_dir="${TMP_DIR}/walls/${category}"
  dst_dir="${WALL_DIR}/${category}"

  if [[ ! -d "${src_dir}" ]]; then
    echo "Skipping missing category: ${category}"
    continue
  fi

  mkdir -p "${dst_dir}"
  mapfile -t files < <(rg --files "${src_dir}" -g "*.jpg" -g "*.jpeg" -g "*.png" -g "*.webp" | shuf)

  count=0
  for f in "${files[@]}"; do
    cp "${f}" "${dst_dir}/"
    ((count += 1))
    if (( count >= PER_CATEGORY )); then
      break
    fi
  done

  echo "  ${category}: ${count} imported"
done

echo "Done. Wallpapers are in ${WALL_DIR}"
echo "Tip: update hyprpaper to point at one file from wallpapers/<category>/"
