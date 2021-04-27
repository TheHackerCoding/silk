import fs from 'fs'
import path from 'path'
import yargs from 'yargs'
import _ from 'lodash'
import { hideBin } from 'yargs/helpers'
const argv = yargs(hideBin(process.argv)).argv
import chunkify from '@sindresorhus/chunkify';
/**/
function log (x) {
	if (process.env.DEV == 1) {
		console.log(x)
	} else {
		return
	}
}

function append(x, y) {
  try {
    fs.appendFileSync(x, y + "\n");
  } catch (error) {
    console.log(error);
  }
}
var uneven
var splitEnds
var split = argv.s
var file = argv.f
var location = path.dirname(file)
if (location == ".") {
	location = process.argv[1]
}



// log(path.dirname(file))
// log(path.basename(file))
// log(path.extname(file))


if (typeof split === 'undefined') {
	split = 5
}

var buf = fs.readFileSync(file).toString(null);

buf = buf.toString().match(new RegExp('.{1,' + 2 + '}', 'g'));
/* <calculations?> */

// console.log(buf)
var chunkSize = _.toInteger(buf.length / split)
var _chunkSize = buf.length % split

splitEnds = [...chunkify(buf,chunkSize)]
log(splitEnds)

if (_chunkSize != 0) {
	// uneven = 1
	var last = _.last(splitEnds)
	// var _last = splitEnds[splitEnds.length - 2]
	splitEnds[splitEnds.length - 2] = splitEnds[splitEnds.length - 2].concat(last)
	splitEnds.pop()
}

/* </calculations?> */
log(splitEnds)



log(chunkSize)
log(_chunkSize)
/* argument vars and other stuff */

/**/