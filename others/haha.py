def crc16(self, strbuf, lenth):
    result = 0
    tempcrc16 = 0
    tempdata = 0
    m = 0
    n = 0
        result = result
        for m in range(lenth):
            result = (result & 0xFFFF)  # 因为Python的int整形数没有最大值，所以需要&上0xffff
            tempcrc16 = (tempcrc16 & 0xFFFF)  # 因为Python的int整形数没有最大值，所以需要&上0xffff
            tempdata = (tempdata & 0xFFFF)  # 因为Python的int整形数没有最大值，所以需要&上0xffff
            tempcrc16 = (((result >> 8) ^ strbuf[m]) & 0xffff)
            tempdata = (tempcrc16 << 8)
            tempcrc16 = 0


            for n in range(8):
                if ((tempdata ^ tempcrc16) & 0x8000):
                    tempcrc16 = (((tempcrc16 << 1)) ^ 0x1021)
                else:
                    tempcrc16 = (tempcrc16 << 1)
                tempdata = (tempdata << 1)
            # print(tempcrc16)
            result = ((result << 8) ^ tempcrc16)

        return result


github = '185.199.110.153'

deb http://mirrors.aliyun.com/ubuntu/ bionic main restricted universe multiverse

deb-src http://mirrors.aliyun.com/ubuntu/ bionic main restricted universe multiverse

 

deb http://mirrors.aliyun.com/ubuntu/ bionic-security main restricted universe multiverse

deb-src http://mirrors.aliyun.com/ubuntu/ bionic-security main restricted universe multiverse

 

deb http://mirrors.aliyun.com/ubuntu/ bionic-updates main restricted universe multiverse

deb-src http://mirrors.aliyun.com/ubuntu/ bionic-updates main restricted universe multiverse

deb http://mirrors.aliyun.com/ubuntu/ bionic-backports main restricted universe multiverse

deb-src http://mirrors.aliyun.com/ubuntu/ bionic-backports main restricted universe multiverse

deb http://mirrors.aliyun.com/ubuntu/ bionic-proposed main restricted universe multiverse

deb-src http://mirrors.aliyun.com/ubuntu/ bionic-proposed main restricted universe multiverse
