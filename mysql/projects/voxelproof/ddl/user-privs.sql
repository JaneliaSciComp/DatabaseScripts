-- ====================== --
-- Apply User Privileges
-- ====================== --
GRANT ALL PRIVILEGES ON voxelproof.* TO voxelproofAdmin@'localhost' identified by 'v0x3lpr00fAdm1n';
GRANT ALL PRIVILEGES ON voxelproof.* TO voxelproofAdmin@'e01u16.int.janelia.org' identified by 'v0x3lpr00fAdm1n';;
GRANT ALL PRIVILEGES ON voxelproof.* TO voxelproofAdmin@'%';

GRANT SELECT,INSERT,UPDATE,DELETE,EXECUTE,SHOW VIEW ON voxelproof.* TO voxelproofApp@'localhost'  identified by 'v0x3lpr00fApp';
GRANT SELECT,INSERT,UPDATE,DELETE,EXECUTE,SHOW VIEW ON voxelproof.* TO voxelproofApp@'e01u16.int.janelia.org'  identified by 'v0x3lpr00fApp';
GRANT SELECT,INSERT,UPDATE,DELETE,EXECUTE,SHOW VIEW ON voxelproof.* TO voxelproofApp@'%';

GRANT SELECT,SHOW VIEW,EXECUTE ON voxelproof.* TO voxelproofRead@'localhost'  identified by  'voxelproofRead';
GRANT SELECT,SHOW VIEW,EXECUTE ON voxelproof.* TO voxelproofRead@'e01u16.int.janelia.org'  identified by  'voxelproofRead';
GRANT SELECT,SHOW VIEW,EXECUTE ON voxelproof.* TO voxelproofRead@'%';
