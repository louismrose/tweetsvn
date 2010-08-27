require 'lib/commit_processor.rb'

class TweeterSpy
  def initialize
    @messages = []
  end
  
  def tweet message
    @messages << message
  end
  
  def tweeted
    @messages
  end
end

describe "commit processor" do

  def publish commit
    @tweeter_spy = TweeterSpy.new
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
    
    @tweeter_spy.tweeted.should == ["Added copyright notice to Flock's Emfatic file. (lrose)"]
  end
  
    it "should not tweet commits with no log message" do
      publish %<Author: lrose
  Date: 2010-03-25 11:04:14 -0400 (Thu, 25 Mar 2010)
  New Revision: 977

  Modified:
    trunk/plugins/org.eclipse.epsilon.flock.engine/src/org/eclipse/epsilon/flock/model/AbstractSyntax.emf
  Log:

  >

      @tweeter_spy.tweeted.should == []
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
     
   it "should tweet one message" do
     @tweeter_spy.tweeted.size.should == 1
   end
        
    it "should compress message to maximum of 120 chars" do
      @tweeter_spy.tweeted.first.length.should == 120
    end

    it "should publish the author in full" do
      @tweeter_spy.tweeted.first.should match /(.*)\(lrose\)/
    end
    
    it "should show include first part of log" do
      @tweeter_spy.tweeted.first.should match /This is an extremely long log message which goes into great detail about the changes made in this SVN commit and (.*)/
    end
  end
  
  context "message with a bugzilla identifier" do
    before(:all) do
      publish %<Author: lrose
Date: 2010-03-25 11:04:14 -0400 (Thu, 25 Mar 2010)
New Revision: 977

Modified:
  trunk/plugins/org.eclipse.epsilon.flock.engine/src/org/eclipse/epsilon/flock/model/AbstractSyntax.emf
Log:
Fixed issue 123456
>
    end

    it "should tweet two messages" do
      @tweeter_spy.tweeted.size.should == 2
    end
    
    it "should tweet commit message first" do
      @tweeter_spy.tweeted[0].should == "Fixed issue 123456 (lrose)"
    end
    
    it "should tweet bugzilla link second" do
      @tweeter_spy.tweeted[1].should == "https://bugs.eclipse.org/bugs/show_bug.cgi?id=123456"
    end
  end
end