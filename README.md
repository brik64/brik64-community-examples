# brik64-community-examples

Example PCD programs for BRIK-64 — the Digital Circuitality compiler.

🌐 [brik64.dev](https://brik64.dev) · 📖 [docs.brik64.dev/pcd/examples](https://docs.brik64.dev/pcd/examples)

## Install brikc

```bash
curl -fsSL https://brik64.dev/install | sh
```

## Examples

```
examples/
├── hello/          # Hello World in PCD
├── fibonacci/      # Recursive Fibonacci
├── crypto/         # SHA256 via MC_48.HASH
├── policy/         # AI action policy circuit
├── stdlib/         # Standard library usage
└── bootstrap/      # brikc CLI dispatcher (brikc.pcd)
```

## Run

```bash
brikc run examples/hello/hello.pcd

# Verify TCE certification (Φ_c must equal 1)
brikc check examples/policy/file_write_policy.pcd
# ✓ Circuit closed: Φ_c = 1.000
```

## Policy Circuit Example

```pcd
// Blocks writes to protected system paths
fn check_write(path, content) {
    let blocked = ["/etc", "/sys", "/boot"];
    loop(array.len(blocked)) as i {
        if (string.starts_with(path, blocked[i])) {
            return "BLOCK: protected path";
        }
    }
    return "ALLOW";
}
MC_40.WRITE(check_write(argv[1], argv[2]));
```

Φ_c = 1 — every input produces ALLOW or BLOCK. No exceptions.

## License

© 2026 BRIK-64 Inc. All rights reserved. Proprietary license.
Examples are provided for learning purposes. Redistribution prohibited.
