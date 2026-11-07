package cmd

import (
	"github.com/astrify/cli/src/utils"
)

// Update is disabled for Astrify
func Update(currentVersion string) bool {
	utils.PrintInfo("Automatic updates are disabled for Astrify.")
	return false
}
