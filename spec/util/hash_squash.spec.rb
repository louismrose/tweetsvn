require 'lib/util/hash_util.rb'

describe "squash hash" do
  
  context "when called on a hash with even dimensions" do
    it "should not change an empty hash" do
      HashUtil.squash({}).should == {}
    end
    
    it "should not change a 1-dimensional hash" do
      hash = { 'username' => 'louis',
               'password' => 'secret' }
               
      HashUtil.squash(hash).should == hash
    end
    
    it "should join the keys of a 2-dimensional hash" do
      hash = { 'gmail'   => {'username' => 'louis', 'password' => 'secret'},
               'twitter' => {'username' => 'lrose', 'password' => 'secret'} }
      
      expected = { 'gmail_username'   => 'louis',
                   'gmail_password'   => 'secret',
                   'twitter_username' => 'lrose',
                   'twitter_password' => 'secret' }
      
      HashUtil.squash(hash).should == expected
    end
    
    it "should join the keys of a 3-dimensional hash" do
      hash = { 'home' =>
               { 
                 'gmail'   => {'username' => 'louis', 'password' => 'secret'},
                 'twitter' => {'username' => 'lrose', 'password' => 'secret'}
               },
               'work' =>
               {
                 'gmail'   => {'username' => 'rose', 'password' => 'secret'},
                 'twitter' => {'username' => 'rose', 'password' => 'secret'}
               } 
              }
      
      expected = { 'home_gmail_username'   => 'louis',
                   'home_gmail_password'   => 'secret',
                   'home_twitter_username' => 'lrose',
                   'home_twitter_password' => 'secret',
                   'work_gmail_username'   => 'rose',
                   'work_gmail_password'   => 'secret',
                   'work_twitter_username' => 'rose',
                   'work_twitter_password' => 'secret' }
      
      HashUtil.squash(hash).should == expected
    end
  end
  
  context "when called on a hash with mixed dimensions" do
    it "should join the keys of the nested hashes" do
      hash = { 'env'   => 'staging',
               'gmail' => {'username' => 'louis', 'password' => 'secret'} }
               
      expected = { 'env' => 'staging',
                   'gmail_username' => 'louis',
                   'gmail_password' => 'secret' }
      
      HashUtil.squash(hash).should == expected
    end
  end
  
  context "when called with an explicit separator" do
    it "should join keys using that separator" do
      hash = { 'gmail' => {'username' => 'louis', 'password' => 'secret'} }
               
      expected = { 'gmail::username' => 'louis',
                   'gmail::password' => 'secret' }
      
      HashUtil.squash(hash, '::').should == expected
    end
  end
  
  context "when called with an explicit prefix" do
    it "should prefix keys with that prefix" do
      hash = { 'gmail' => {'username' => 'louis', 'password' => 'secret'} }
               
      expected = { 'mygmail_username' => 'louis',
                   'mygmail_password' => 'secret' }
      
      HashUtil.squash(hash, '_', 'my').should == expected
    end
  end
end