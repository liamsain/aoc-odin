package main
import "core:fmt"
import "core:strconv"
import "core:strings"
import "core:time"

main :: proc() {
  total := 0
	input: string = "554735 45401 8434 0 188 7487525 77 7"
	start := time.tick_now()
	tokens := strings.split(input, " ")

	stoneMap := make(map[string]int)

	for token in tokens {
		stoneMap[token] += 1
	}
  fmt.println(stoneMap)

  tmp := make(map[string]int)
	for _ in 0 ..< 2 {
		total = 0
		defer clear(&tmp)

		for k, v in stoneMap {
			len_k := len(k)
			fmt.printf("key:%s, len:%d, val:%d\n", k, len_k, v)
			if k == "0" {
				fmt.println("changing 0 to 1")
				if "1" in tmp {
					tmp["1"] += v
				} else {
					tmp["1"] = v
				}
				total += v
			} else {

				if len_k % 2 == 0 {
					firstHalfKey := k[:len_k / 2]
					secondHalfKey := k[len_k / 2:]
					if firstHalfKey in tmp {
						tmp[firstHalfKey] += v
					} else {
						tmp[firstHalfKey] = v
					}
          // convert secondHalfKey to int to deal with leading 0s
					secondHalfKeyNum := strconv.atoi(secondHalfKey)
					buf: [20]byte
					secondHalfStr := strconv.itoa(buf[:], secondHalfKeyNum)
					fmt.printf(
						"firsthalf:%s,len: %d, secondhalf:%s, len: %d.\n",
						firstHalfKey,
					  len(firstHalfKey),
						secondHalfStr,
					  len(secondHalfStr)
					)
					if secondHalfStr in tmp {
						tmp[secondHalfStr] += v
					} else {
						tmp[secondHalfStr] = v
					}
					total += v * 2
				} else {
					kNum := strconv.atoi(k)
					res := kNum * 2024
					buf: [20]byte
					newKey := strconv.itoa(buf[:], res)
					if newKey in tmp {
						tmp[newKey] += v
					} else {
						tmp[newKey] = v
					}
					total += v
					fmt.printf("new key:%s,len:%d.\n", newKey, len(newKey))
				}
			}
		}
    fmt.println(tmp)
		fmt.println("")
		clear(&stoneMap)
		for k, v in tmp {
			stoneMap[k] = v
		}
	}


	microseconds := time.duration_microseconds(time.tick_since(start))
	fmt.printf("%f microseconds\n", microseconds)
	fmt.println("Part 1:", total)
}
