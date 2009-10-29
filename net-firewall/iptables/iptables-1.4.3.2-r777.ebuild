# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-firewall/iptables/iptables-1.4.3.2.ebuild,v 1.9 2009/08/31 00:29:33 ranger Exp $

inherit eutils toolchain-funcs

DESCRIPTION="Linux kernel (2.4+) firewall, NAT and packet mangling tools"
HOMEPAGE="http://www.iptables.org/"
IMQ_PATCH="iptables-1.4.3.2-imq_xt.diff"
SRC_URI="http://iptables.org/projects/iptables/files/${P}.tar.bz2
	imq? ( http://www.linuximq.net/patchs/${IMQ_PATCH} )"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86"
IUSE="imq"

DEPEND="virtual/os-headers
	imq? ( virtual/linux-sources )"
RDEPEND=""

src_unpack() {
	unpack ${P}.tar.bz2
	cd "${S}"
	epatch_user

	if use imq ; then
		EPATCH_OPTS="-p1" epatch "${DISTDIR}"/${IMQ_PATCH}
                chmod +x extensions/.IMQ-test*
        fi
}

src_compile() {
	econf \
		--sbindir=/sbin \
		--libexecdir=/$(get_libdir) \
		--enable-devel \
		--enable-libipq \
		--enable-shared \
		--enable-static
	emake V=1 || die
}

src_install() {
	emake install DESTDIR="${D}" || die

	insinto /usr/include
	doins include/iptables.h include/ip6tables.h || die
	insinto /usr/include/iptables
	doins include/iptables/internal.h || die

	keepdir /var/lib/iptables
	newinitd "${FILESDIR}"/${PN}-1.3.2.init iptables || die
	newconfd "${FILESDIR}"/${PN}-1.3.2.confd iptables || die
	keepdir /var/lib/ip6tables
	newinitd "${FILESDIR}"/iptables-1.3.2.init ip6tables || die
	newconfd "${FILESDIR}"/ip6tables-1.3.2.confd ip6tables || die
}
