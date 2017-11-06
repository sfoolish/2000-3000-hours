package main

import (
	"exec"
	"time"
)

// http://ulricqin.com/post/set-script-timeout-use-golang/
// https://www.johnsto.co.uk/blog/function-timeouts-in-go/

func CmdRunWithTimeout(cmd *exec.Cmd, timeout time.Duration) (error, bool) {
	done := make(chan error)
	go func() {
		done <- cmd.Wait()
	}()

	var err error
	select {
	case <-time.After(timeout):
		// timeout
		if err = cmd.Process.Kill(); err != nil {
			log.Error("failed to kill: %s, error: %s", cmd.Path, err)
		}
		go func() {
			<-done // allow goroutine to exit
		}()
		log.Info("process:%s killed", cmd.Path)
		return err, true
	case err = <-done:
		return err, false
	}
}

func main() {

	cmd := exec.Command(realRun)
	var stdout bytes.Buffer
	cmd.Stdout = &stdout
	var stderr bytes.Buffer
	cmd.Stderr = &stderr
	cmd.Start() // attention!
	var isTimeout bool
	err, isTimeout = systool.CmdRunWithTimeout(cmd, time.Duration(t)*time.Second)

}
