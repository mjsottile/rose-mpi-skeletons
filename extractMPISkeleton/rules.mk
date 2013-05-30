ifeq ($(V),)
  quiet     = quiet_
  Q         = @
  MAKEFLAGS += -s
else
  quiet  =
  Q      =
endif

echo_cmd = $(if $($(quiet)cmd_$(1)), echo "  $($(quiet)cmd_$(1))";,echo "HUH: $1";)
     cmd = @$(echo_cmd) $(cmd_$(1))

      cmd_cc_to_o  = $(CXX) $(CXXFLAGS) $($(notdir $*)_CXXFLAGS) -c -o $@ $<
quiet_cmd_cc_to_o  = CXX     $(notdir $@)
%.o: %.cc
	$(call cmd,cc_to_o)

# This dependency generation comes from here: http://locklessinc.com/articles/makefile_tricks/
# The sed magic was not very portable, so removing it for now.
#      cmd_cc_to_dep = $(CXX) -MM $(CXXFLAGS) $($(notdir $*)_CXXFLAGS) $< | sed -n 'H;$$ {g;s@.*:\(.*\)@$< := \$$\(wildcard\1\)\n$*.o $@: $$\($<\)@;p}' > $@
       cmd_cc_to_dep = $(CXX) -MM $(CXXFLAGS) $($(notdir $*)_CXXFLAGS) $< > $@
quiet_cmd_cc_to_dep = DEPEND  $(notdir $@)
.depend.%.cc.P: %.cc
	$(call cmd,cc_to_dep)

dependless  = %.o %.a .depend.%.P %.h
expand      = $($(1)) $(1) $(dir $(1)).depend.$(notdir $(1)).P
depend_test = $(if $(filter $(dependless),$(var)),$(var),$(call expand,$(var)))
depend      = $(sort $(foreach var,$(1),$(depend_test)))

src2depend  = $(dir $(1)).depend.$(notdir $(1)).P

# Use this in place of $^
& = $(filter-out %.h %.P,$^)

      cmd_o_to_bin = $(CXX) $(CXXFLAGS) $($(notdir $@)_CXXFLAGS) $(LDFLAGS) $& -o $@
quiet_cmd_o_to_bin = CXX     $(notdir $@)

# Project specific rules
ifdef ROSEINSTALL
CXXFLAGS += -isystem $(ROSEINSTALL)/include
LDFLAGS  += -L$(ROSEINSTALL)/lib
endif
ifdef BOOSTINSTALL
CXXFLAGS += -isystem $(BOOSTINSTALL)/include
LDFLAGS  += -L$(BOOSTINSTALL)/lib
endif
