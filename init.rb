# Include hook code here
ActionView::Base.send(:include, HatchetHarry)
ActiveRecord::Base.send(:include, HatchetHarry)
ActionController::Base.send(:include, HatchetHarry)
