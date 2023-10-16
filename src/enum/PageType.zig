pub const PageType = enum(u8) {
    DATA_PAGE = 0,
    INDEX_PAGE = 1,
    DICTIONARY_PAGE = 2,
    DATA_PAGE_V2 = 3,

    pub fn fromValue(value: u8) !PageType {
        if (value > 3) {
            return error.InvalidPageTypeValue;
        }
        return @as(PageType, @enumFromInt(value));
    }
};
