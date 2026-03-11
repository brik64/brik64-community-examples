#!/bin/bash
# BRIK-64 Self-Hosting Bootstrap — no Rust dependency
# Requires: brikc native ELF binary in the same directory
set -euo pipefail

BRIKC="${BRIKC:-./brikc_native}"
BRIKC_PCD="brikc.pcd"

if [ ! -x "$BRIKC" ]; then
    echo "ERROR: $BRIKC not found or not executable"
    echo "Generate it with: brikc build brikc_cli_dispatch.pcd --target elf -o ."
    exit 1
fi

echo "=== BRIK-64 Self-Hosting Bootstrap ==="
echo "Compiler: $BRIKC"
echo "Source:   $BRIKC_PCD"
echo ""

echo "Stage 0: Compiling $BRIKC_PCD → Gen1 BIR..."
$BRIKC compile "$BRIKC_PCD" > gen1.bir
GEN1_HASH=$(sha256sum gen1.bir | cut -d' ' -f1)
echo "Gen1 hash: $GEN1_HASH"
echo "Gen1 size: $(wc -c < gen1.bir) bytes"
echo ""

echo "Stage 1: Gen1 compiling $BRIKC_PCD → Gen2 BIR..."
$BRIKC run gen1.bir "$BRIKC_PCD" > gen2.bir
GEN2_HASH=$(sha256sum gen2.bir | cut -d' ' -f1)
echo "Gen2 hash: $GEN2_HASH"
echo "Gen2 size: $(wc -c < gen2.bir) bytes"
echo ""

if [ "$GEN1_HASH" = "$GEN2_HASH" ]; then
    echo "✓ FIXPOINT VERIFIED"
    echo "  SHA-256: $GEN1_HASH"
    echo "  The compiler compiles itself and produces identical output."
    exit 0
else
    echo "✗ FIXPOINT FAILED"
    echo "  Gen1: $GEN1_HASH"
    echo "  Gen2: $GEN2_HASH"
    diff gen1.bir gen2.bir | head -20
    exit 1
fi
