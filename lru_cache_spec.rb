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

    it '初期値が省略されると、デフォルト値が使われる' do
			@lru = LRUCache.new
      @lru.max_size.should == 10
    end
	
		it '初期化子に与えたLRUCacheのサイズが正しいこと' do
			@lru = LRUCache.new(2)
			@lru.max_size.should == 2
		end

		it '0以下の値を初期化子に与えるとLRUCacheExceptionを返す' do
			lambda{
				LRUCache.new(0)
			}.should raise_error(LRUCacheException)
	
			lambda{
				LRUCache.new(-1)
			}.should raise_error(LRUCacheException)
		end 
    
    it '整数以外が渡された場合、LRUCacheExceptionを返す' do
			lambda{
				LRUCache.new("1")
			}.should raise_error(LRUCacheException)
			lambda{
				LRUCache.new(2.2)
			}.should raise_error(LRUCacheException)
    end

		it '上限の指定がない場合、LRUCacheExceptionを返す' do
			lambda{
				LRUCache.new(nil)
			}.should raise_error(LRUCacheException)
		end
  end

  describe "記憶サイズの変更" do
		before (:each) do
			@lru = LRUCache.new(2)
		end

    it "記憶サイズを増やす" do 
			@lru.put("a", "dataA")
			@lru.put("b", "dataB")
      @lru.max_size = 3
			@lru.put("c", "dataC")
			@lru.get("a").should == "dataA"
    end

    it "記憶サイズを減らす" do 
			@lru.put("a", "dataA")
			@lru.put("b", "dataB")
      @lru.max_size = 1
			@lru.get("a").should be_nil
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
	    @lru.put("a", "dataA")
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
			@lru.oldest_key.should == "b"
			@lru.get("b")
			@lru.oldest_key.should == "a"
		end

    it "追加済みのキーを更新できる" do
			@lru.put("a", "dataA")
			@lru.put("b", "dataB")
			@lru.put("a", "dataa")
			@lru.oldest_key.should == "b"
			@lru.get("a").should == "dataa"
		end
    
	  it '値を4つ登録すると最初に登録したkeyを参照するとnilが返ること' do
			@lru.put("a", "dataA")
			@lru.put("b", "dataB")
			@lru.put("c", "dataC")
			@lru.put("d", "dataD")
			@lru.get("a").should be_nil
		end

    it "未登録時にもっとも参照されていないキーを取り出すと例外が投げられる" do
			lambda{
				@lru.oldest_key 
			}.should raise_error(LRUCacheException)
    end

  end

  describe "一定時間過ぎたデータの削除" do
		before (:each) do
			@lru = LRUCache.new(3)
		end

    it "記憶時間の初期値が設定されていること" do
      @lru.expire.should == 360000
    end

    it "記憶時間の設定メソッドのテスト" do
      @lru.expire = 300
      @lru.expire.should == 300
    end

    it "一定時間過ぎてキャッシュが削除されていることのテスト" do
      @lru.expire = 100
			@lru.put("a", "dataA")
      sleep(0.2)
			@lru.get("a").should be_nil
    end

    it "一定時間内に参照があれば、追加時刻を更新" do
      @lru.expire = 100
			@lru.put("a", "dataA")
      sleep(0.05)
			@lru.get("a").should == "dataA"
      sleep(0.06)
			@lru.get("a").should == "dataA"
      sleep(0.2)
			@lru.get("a").should be_nil
    end

  end
end

