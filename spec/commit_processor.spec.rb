require 'lib/commit_processor.rb'

class TweeterSpy
  def tweet message
    @message = message
  end
  
  def tweeted
    @message
  end
end

describe "commit processor" do
  before(:all) do
    @tweeter_spy = TweeterSpy.new
  end
  
  def publish commit
    CommitProcessor.new(@tweeter_spy).publish commit
  end
  
  it "should tweet the log followed by the author" do
    publish %<Author: lrose
Date: 2010-03-25 11:04:14 -0400 (Thu, 25 Mar 2010)
New Revision: 977

Modified:
  trunk/plugins/org.eclipse.epsilon.flock.engine/src/org/eclipse/epsilon/flock/model/AbstractSyntax.emf
Log:
Added copyright notice to Flock's Emfatic file.
>
    
    @tweeter_spy.tweeted.should == "Added copyright notice to Flock's Emfatic file. (lrose)"
  end
  
  context "long message" do
    before(:all) do
      publish %<Author: lrose
Date: 2010-03-25 11:04:14 -0400 (Thu, 25 Mar 2010)
New Revision: 977

Modified:
  trunk/plugins/org.eclipse.epsilon.flock.engine/src/org/eclipse/epsilon/flock/model/AbstractSyntax.emf
Log:
This is an extremely long log message which goes into great detail about the changes made in this SVN commit and which cannot be displayed in a Twitter message, because it has more than one hundred and forty
characters.
>
    end
        
    it "should compress message to maximum of 120 chars" do
      @tweeter_spy.tweeted.length.should == 120
    end

    it "should publish the author in full" do
      @tweeter_spy.tweeted.should match /(.*)\(lrose\)/
    end
    
    it "should show include first part of log" do
      @tweeter_spy.tweeted.should match /This is an extremely long log message which goes into great detail about the changes made in this SVN commit and (.*)/
    end
  end
end