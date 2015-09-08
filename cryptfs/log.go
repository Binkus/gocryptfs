package cryptfs

import (
	"fmt"
)

type logChannel struct {
	enabled bool
}

func (l logChannel) Printf(format string, args ...interface{}) {
	if l.enabled == true {
		fmt.Printf(format, args...)
	}
}


var Debug = logChannel{false}
var Warn = logChannel{true}
