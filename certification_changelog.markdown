# Material changes

# Immaterial changes
- Add `energy` impact calculation (4fc69659f847878d6a3b4311e1d7ab995fbb9b44)
- Don't calculate each emission factor separately (2f759ee399fbfbcf894349f94881b4d753465429)
- Move most fallbacks to `Country` (bb3c6f2251abeeb955dc6b6cc15a222b0e9842d2)
- Simplify user input of make/model/year (8a9d4e90ed1801ff00c4a0220b1a514ceb25563d)
- Add scope description (dbd14a080d719beaae36a10d8cb70eff841a0ca6)
- Cut `urbanity_estimate` - user provides `urbanity`. This is immaterial because CM1 ensures that user-input `urbanity` is from 0 to 1 inclusive (1b957d1e75b7618fa83a882bbbdc14c62801a912)
- Change `duration` from minutes to seconds (a303b6ea3cec4c64a26e2d35e41d273c8dee06c0)

# Latest 3rd-party review
b43ba1d95e7c2d376879529e0211c9414e190693

- - -

**Certification only applies if using a certified version of Earth**
