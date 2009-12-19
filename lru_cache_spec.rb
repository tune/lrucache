require 'rubygems'
require 'spec'

require 'lru_cache'

describe LRUCache do
	describe "初期化関連" do
		before (:each) do
			@lru = nil
		end
	
		it 'クラスが初期化出来ること' do
			@lru = LRUCache.new(2)
		end
	
		it '初期化子に与えたLRUCacheのサイズが正しいこと' do
			@lru = LRUCache.new(2)
			@lru.size.should == 2
		end

		it '0以下の値を初期化子に与えるとLRUCacheExceptionを返す' do
			lambda{
				LRUCache.new(0)
			}.should raise_error(LRUCacheException)
	
			lambda{
				LRUCache.new(-1)
			}.should raise_error(LRUCacheException)
		end 

		it '上限の指定がない場合、LRUCacheExceptionを返す' do
			lambda{
				LRUCache.new(nil)
			}.should raise_error(LRUCacheException)
		end
	end

	describe "put, getの操作関連" do
		before (:each) do
			@lru = LRUCache.new(3)
		end
	
		it '直前にputした値が参照できること' do
			@lru.put("a", "dataA")
			@lru.get("a").should == "dataA"
			@lru.put("b", "dataB")
			@lru.get("b").should == "dataB"
		end
	
	    it 'keyとして登録されていないものはnilが返ること' do
	      @lru.put("a", "dataA");
	      @lru.get("b").should be_nil
	    end
	
	    it 'keyがnilの場合も設定した値が返ること' do
	      @lru.put(nil, "nilobject")
	      @lru.get(nil).should == "nilobject"
	    end
	    
	    it '値を３つ以上登録すると最後に登録したものが残っていること' do
			@lru.put("a", "dataA")
			@lru.put("b", "dataB")
			@lru.put("c", "dataC")
	        @lru.get("c").should == "dataC"
		end
    
	    it "getで値を参照すると最も参照されてないキーが更新されること" do
			@lru.put("a", "dataA")
			@lru.put("b", "dataB")
			@lru.get("a")
			@lru.last_recently_used.should == "b"
			@lru.get("b")
			@lru.last_recently_used.should == "a"
		end
    
	    it '値を4つ登録すると最初に登録したkeyを参照するとnilが返ること' do
			@lru.put("a", "dataA")
			@lru.put("b", "dataB")
			@lru.put("c", "dataC")
			@lru.put("d", "dataD")
			@lru.get("a").should be_nil
		end
    end
end

