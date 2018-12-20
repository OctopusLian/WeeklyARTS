[(x, y, z, n) |
       x <- [2, 3],
       y <- [(x + 1) .. 6],
       z <- [(y + 1) .. 12], let d = x * y * z - y * z - x * z - x * y, d > 0,
       let n = (y * z + x * z + x * y) `div` d,
       (n + 1) `div` x + (n + 1) `div` y + (n + 1) `div` z == n]